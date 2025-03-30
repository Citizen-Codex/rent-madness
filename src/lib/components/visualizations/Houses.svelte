<script lang="ts">
	// @ts-expect-error: No types available for svelte-scroller
	import Scroller from '@sveltejs/svelte-scroller';
	import Picture from '$lib/components/media/Picture.svelte';
	import { fade, fly } from 'svelte/transition';
	import md from '$lib/utils/md';

	const steps = [
		{
			src: 'houses/step-1.png',
			alt: 'Houses base wireframe'
		},
		{
			src: 'houses/step-2.png',
			alt: 'Houses filled in with cost burdened percentage',
			annotation:
				'**22.4 million renter households** were [cost-burdened]{.bg-yellow .highlighted} in 2023 (spending more than 30 percent of their income on housing costs).',
			annotationClasses: 'border-yellow bottom-11/12 pb-10 border-l-2 pl-4 left-12'
		},
		{
			src: 'houses/step-3.png',
			alt: 'Houses filled in with severely cost burdened percentage',
			annotation:
				'A record-high **12.1 million households** were [severely cost-burdened]{.bg-pink-light .highlighted} (paying more than 50 percent of their income on housing costs).',
			annotationClasses: 'border-pink right-8 top-5/6 pt-8 border-r-2 text-right pr-4'
		}
	];

	let index: number | undefined = $state();
</script>

<Scroller top={0.2} threshold={0.5} bottom={0.9} query=".step" bind:index>
	{#snippet background()}
		<div class="flex h-[70vh] flex-col items-center justify-center">
			<div class="content-well-medium absolute">
				<Picture {...steps[0]} alt="" class="mx-auto  max-h-[calc(70vh-200px)] w-fit" />
				{#each steps as { src, alt, annotation, annotationClasses }, i (i)}
					{#if i <= (index ?? 0) && i !== 0}
						<div transition:fade class="absolute inset-x-4 inset-y-0 md:inset-x-8">
							<Picture {src} {alt} class="mx-auto max-h-[calc(70vh-200px)] w-fit" />
						</div>

						<div
							transition:fly={{ y: 15 }}
							class={['markdown absolute max-w-3xs text-sm md:text-base', annotationClasses]}
						>
							{@html md(annotation ?? '')}
						</div>
					{/if}
				{/each}
			</div>
		</div>
	{/snippet}

	{#snippet foreground()}
		{#each steps as _, i (i)}
			<div class="step h-screen"></div>
		{/each}
	{/snippet}
</Scroller>
