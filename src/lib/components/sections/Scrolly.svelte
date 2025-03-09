<script lang="ts">
	import Basemap, { baseView } from '$lib/components/visualizations/Basemap.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import IconCircle from '$lib/components/fragments/IconCircle.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	// @ts-expect-error: No types available for svelte-scroller
	import Scroller from '@sveltejs/svelte-scroller';

	const content = page.data['chapter-2'];
	let index: number | undefined = $state();
	let view = $derived(
		!index || index === 0 || !content.steps[index - 1].view
			? baseView
			: content.steps[index - 1].view
	);
</script>

<Scroller top={0} threshold={0.7} bottom={0.9} query=".step" bind:index>
	{#snippet background()}
		<Basemap {view} />
	{/snippet}

	{#snippet foreground()}
		<div class="relative flex flex-col items-center px-4 md:px-8">
			<!-- Intro -->
			<div
				class="step mr-auto mb-[90vh] flex w-full max-w-md flex-col gap-10 rounded-lg border bg-white px-6 py-8"
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
					<p class="highlighted">{@html md(step.content)}</p>
				</div>
			{/each}

			<!-- Explorer -->
		</div>
	{/snippet}
</Scroller>

<style lang="postcss">
	@reference '$lib/styles/app.css';

	p.highlighted :global(span) {
		@apply -mx-0.5 rounded px-0.5;
	}
</style>
