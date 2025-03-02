<script module lang="ts">
	import { PUBLIC_MAPBOX_ACCESS_TOKEN } from '$env/static/public';
	import mapbox, { type Map } from 'mapbox-gl';
	import 'mapbox-gl/dist/mapbox-gl.css';

	mapbox.accessToken = PUBLIC_MAPBOX_ACCESS_TOKEN;

	const mapStyle = 'mapbox://styles/arjunkakkar8/clzoilzc1006y01pzaqwl1csh';

	export const baseView = { zoom: 3.64, center: [-97.648, 40.205] };
</script>

<script lang="ts">
	import { onMount, onDestroy } from 'svelte';

	const { view } = $props();

	let map: Map | null = $state(null);
	let mapContainer: HTMLElement | null = $state(null);
	let loaded = $state(false);

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

		// disable map rotation
		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();

		loaded = true;
	});

	onDestroy(() => {
		if (map) map.remove();
	});

	$effect(() => {
		if (map)
			map.flyTo({
				...view,
				essential: true
			});
	});
</script>

<figure class="relative h-full min-h-screen w-full">
	<div class="absolute inset-0">
		<div class="h-full w-full" bind:this={mapContainer}></div>
	</div>
	{#if !loaded}
		<div class="absolute inset-0 flex items-center justify-center">
			<div class="text-2xl text-white">Loading...</div>
		</div>
	{/if}
</figure>
