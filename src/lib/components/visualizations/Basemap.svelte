<script module lang="ts">
	import { PUBLIC_MAPBOX_ACCESS_TOKEN } from '$env/static/public';
	import mapbox, { type Map, type NavigationControl } from 'mapbox-gl';
	import 'mapbox-gl/dist/mapbox-gl.css';

	import { formatNumber, formatPercent } from '$lib/utils/format';

	mapbox.accessToken = PUBLIC_MAPBOX_ACCESS_TOKEN;

	const mapStyle = 'mapbox://styles/arjunkakkar8/clzoilzc1006y01pzaqwl1csh';
	const source = 'composite';
	const sourceLayer = 'merged_rent_data_zip_sf';
	const layer = 'zip-rent-disparity';

	export const baseView = { zoom: 3.64, center: [-97.648, 40.205] };
	export const loaded = $state({ value: false });
</script>

<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import MapLegend from './MapLegend.svelte';
	import { ScrollTrigger } from 'gsap/ScrollTrigger';

	let { view, setView = $bindable(), mapInteractive, index } = $props();

	let map: Map | null = $state(null);
	let mapContainer: HTMLElement | null = $state(null);
	let mapControl: NavigationControl | null = $state(null);
	let viewOverride = false;
	let hoveredId = $state<string>();
	const popup = new mapbox.Popup({ closeButton: false, closeOnClick: false });

	onMount(async () => {
		if (!mapbox.supported()) {
			console.log('Your browser does not support Mapbox GL');
			return;
		}

		if (!mapContainer) return;

		map = new mapbox.Map({
			style: mapStyle,
			container: mapContainer,
			minZoom: 4,
			maxZoom: 13
		});

		await map.once('load');
		ScrollTrigger.refresh();

		mapControl = new mapbox.NavigationControl({ showCompass: false });

		// disable map rotation
		map.scrollZoom.disable();
		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();
		map.on('mousedown', () => {
			viewOverride = true;
			setView = undefined;
		});

		// add hover interaction
		map.on('mousemove', layer, (e) => {
			if (!e.features || e.features?.length === 0 || !map) return;
			if (hoveredId !== undefined) {
				map.setFeatureState({ source, sourceLayer, id: hoveredId }, { hover: false });
			}
			hoveredId = String(e.features[0].id);
			map.setFeatureState({ source, sourceLayer, id: hoveredId }, { hover: true });

			const data = e.features[0].properties;
			if (!data || !(data.MEAN_ZORI || data.MEDIAN_ACS_RENT)) {
				map.getCanvas().style.cursor = '';
				popup.remove();
				return;
			}
			map.getCanvas().style.cursor = 'pointer';
			popup
				.setLngLat(e.lngLat)
				.setHTML(
					`<div class="markdown font-serif flex flex-col gap-2">
			<p>
				<strong>${data.PO_NAME}, ${data.STATE}: ${data.ZIP}</strong> has ${
					data.MEAN_ZORI
						? `a mean Zillow Observed Rent
					Index value of
					<span class="bg-orange-light/40 highlighted font-mono"
						>${formatNumber(data.MEAN_ZORI)}</span
					>
					and`
						: ''
				}
				 ${
						data.MEDIAN_ACS_RENT
							? `a median rent of
				<span class="bg-yellow-light highlighted font-mono">${formatNumber(data.MEDIAN_ACS_RENT)}</span>
				measured by the American Community Survey.`
							: ''
					}
			</p>
			${
				data.MEAN_ZORI && data.MEDIAN_ACS_RENT
					? `<p>
					The disparity between the two measures is
					<span class="bg-gray-light highlighted font-mono font-bold"
						>${formatPercent((data.MEAN_ZORI - data.MEDIAN_ACS_RENT) / data.MEDIAN_ACS_RENT)}</span
					>.
				</p>`
					: ''
			}
		</div>`
				)
				.addTo(map);
		});

		map.on('mouseleave', layer, () => {
			if (hoveredId !== undefined) {
				map?.setFeatureState({ source, sourceLayer, id: hoveredId }, { hover: false });
			}
			hoveredId = undefined;
			map.getCanvas().style.cursor = '';
			popup.remove();
		});

		map.setPaintProperty(layer, 'fill-opacity', [
			'case',
			['boolean', ['feature-state', 'hover'], false],
			1,
			0.7
		]);

		map.setPaintProperty(layer, 'fill-outline-color', [
			'case',
			['boolean', ['feature-state', 'hover'], false],
			'rgba(0, 0, 0, 1)',
			'rgba(0, 0, 0, 0.05)'
		]);

		loaded.value = true;
	});

	onDestroy(() => {
		if (map) map.remove();
	});

	$effect(() => {
		if (!map) return;
		const currentView = mapInteractive ? setView || view : view;

		if (currentView.center && !viewOverride) {
			map.flyTo({
				...currentView,
				essential: true
			});
		} else if (currentView.bbox) {
			map.fitBounds(currentView.bbox, { essential: true });
		}
		viewOverride = false;
	});

	$effect(() => {
		if (!map || !mapControl) return;

		if (mapInteractive) {
			map.addControl(mapControl, 'bottom-right');
		} else {
			map.removeControl(mapControl);
			popup.remove();
		}
	});
</script>

<figure
	class={[
		'relative h-full min-h-screen w-full',
		mapInteractive ? 'pointer-events-auto' : 'pointer-events-none'
	]}
>
	<div class="absolute inset-0">
		<div class="h-full w-full" bind:this={mapContainer}></div>
		{#if index && index > 0}
			<MapLegend />
		{/if}
	</div>
	{#if !loaded.value}
		<div class="absolute inset-0 flex items-center justify-center">
			<div class="text-2xl text-white">Loading...</div>
		</div>
	{/if}
</figure>

<style lang="postcss">
	@reference '$lib/styles/app.css';

	:global(.mapboxgl-popup-content) {
		@apply rounded-lg border border-black bg-white px-4 py-3 shadow;
	}

	:global(.mapboxgl-popup-tip) {
		@apply opacity-60;
	}
</style>
