<script module lang="ts">
	import { PUBLIC_MAPBOX_ACCESS_TOKEN } from '$env/static/public';
	import mapbox, { type Map, type NavigationControl } from 'mapbox-gl';
	import 'mapbox-gl/dist/mapbox-gl.css';

	mapbox.accessToken = PUBLIC_MAPBOX_ACCESS_TOKEN;

	const mapStyle = 'mapbox://styles/arjunkakkar8/clzoilzc1006y01pzaqwl1csh';

	export const baseView = { zoom: 3.64, center: [-97.648, 40.205] };
	export const loaded = $state({ value: false });
</script>

<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import MapLegend from './MapLegend.svelte';

	let { view, setView = $bindable(), mapInteractive, index } = $props();

	let map: Map | null = $state(null);
	let mapContainer: HTMLElement | null = $state(null);
	let mapControl: NavigationControl | null = $state(null);
	let viewOverride = false;

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

		mapControl = new mapbox.NavigationControl({ showCompass: false });

		// disable map rotation
		map.scrollZoom.disable();
		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();
		map.on('mousedown', () => {
			viewOverride = true;
			setView = undefined;
		});

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
		<MapLegend />
	</div>
	{#if !loaded.value}
		<div class="absolute inset-0 flex items-center justify-center">
			<div class="text-2xl text-white">Loading...</div>
		</div>
	{/if}
</figure>
