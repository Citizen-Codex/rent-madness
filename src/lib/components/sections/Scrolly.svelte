<script lang="ts">
	import { PUBLIC_MAPBOX_ACCESS_TOKEN } from '$env/static/public';
	import Basemap, { baseView, loaded } from '$lib/components/visualizations/Basemap.svelte';
	import mapbox from 'mapbox-gl';
	import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import IconCircle from '$lib/components/fragments/IconCircle.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	// @ts-expect-error: No types available for svelte-scroller
	import Scroller from '@sveltejs/svelte-scroller';
	// @ts-expect-error: No types available for mapbox-gl-geocoder
	import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

	const content = page.data['chapter-2'];
	let index: number | undefined = $state();
	let view = $derived(
		!index || index === 0 || !content.steps[index - 1]?.view
			? baseView
			: content.steps[index - 1].view
	);
	let setView: MapView | undefined = $state(undefined);
	let mapInteractive = $derived(index === content.steps.length + 1);

	$effect(() => {
		if (!loaded.value) return;
		const geocoder = new MapboxGeocoder({
			accessToken: PUBLIC_MAPBOX_ACCESS_TOKEN,
			mapboxgl: mapbox,
			countries: 'us'
		});
		geocoder.on('result', function ({ result }: unknown) {
			if (!result?.bbox) return;
			setView = {
				bbox: result.bbox
			};
		});

		geocoder.addTo('.geocoder');
		geocoder.setPlaceholder('City, Zip Code...');
	});
</script>

<section id="explore">
	<Scroller top={0} threshold={0.7} bottom={1} query=".step" bind:index>
		{#snippet background()}
			<Basemap {view} {mapInteractive} bind:setView {index} />
		{/snippet}

		{#snippet foreground()}
			<div class="flex flex-col items-center px-4 md:px-8">
				<!-- Intro -->
				<div
					class="step mt-16 mr-auto mb-[90vh] flex w-full max-w-md flex-col gap-10 rounded-lg border bg-white px-6 py-8"
				>
					<ChapterNumber>2</ChapterNumber>
					<h2 class="heading">{content.hed}</h2>
					<p class="body">{content.dek}</p>
					<div class="cta flex items-center gap-4">
						{content.cta}
						<IconCircle icon="mdi:chevron-down" class="bg-orange text-2xl text-white" />
					</div>
				</div>

				<!-- Steps -->
				{#each content.steps as step, i (i)}
					<div class="body step bg-white-true mb-[90vh] max-w-md rounded border border-black p-6">
						{@html md(step.content)}
					</div>
				{/each}

				<!-- Explorer -->
				<div
					class="step mb sticky -top-[300px] mr-auto mb-20 flex w-full max-w-lg flex-col gap-10 rounded-lg border bg-white px-6 py-8"
				>
					<h3 class="heading-small">{content.explorer.hed}</h3>
					<p class="body">{content.explorer.content}</p>
					<div class="flex flex-col gap-4 border-t-2 border-black pt-4">
						<p class="cta flex items-center gap-4">
							{content.explorer.cta}
						</p>
						<div class="geocoder"></div>
						<div class="flex flex-wrap gap-2">
							{#each content.explorer.cities as { name, view: cityView } (name)}
								<button
									onclick={() => (setView = cityView)}
									class={[
										'cta-small hover:bg-orange-light outline-orange cursor-pointer border border-black p-2 transition-colors focus:outline',
										JSON.stringify(cityView) === JSON.stringify(setView) &&
											'bg-orange pointer-events-none text-white'
									]}>{name}</button
								>
							{/each}
						</div>
					</div>
				</div>

				<div class="h-[calc(100vh-174px)]"></div>
			</div>
		{/snippet}
	</Scroller>
</section>

<style lang="postcss">
	@reference '$lib/styles/app.css';

	:global(svelte-scroller-foreground) {
		@apply pointer-events-none;
	}

	:global(svelte-scroller-background),
	.step {
		@apply pointer-events-auto;
	}

	.geocoder {
		:global(.mapboxgl-ctrl-geocoder) {
			@apply w-full max-w-none rounded-none border border-black bg-transparent shadow-none;
		}

		:global(.mapboxgl-ctrl-geocoder--input) {
			@apply font-mono text-black placeholder:font-mono;
		}

		:global(.suggestions) {
			@apply rounded-none border border-black bg-white;

			:global(.active > a) {
				@apply bg-gray-light;
			}

			:global(a) {
				@apply hover:bg-gray-light font-mono;
			}
		}

		:global(.mapboxgl-ctrl-geocoder--powered-by) {
			@apply !hidden;
		}
	}
</style>
