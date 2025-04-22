<script lang="ts">
	// @ts-expect-error: No types available for svelte-scroller
	import Scroller from '@sveltejs/svelte-scroller';
	import Picture from '$lib/components/media/Picture.svelte';
	import { fade, fly } from 'svelte/transition';
	import md from '$lib/utils/md';

	const steps = [
		{
			src: 'houses/step-1.png',
			alt: 'Houses base wireframe',
			sizeClass: 'h-[50vh]'
		},
		{
			src: 'houses/step-2.png',
			alt: 'Houses filled in with cost burdened percentage',
			annotation:
				'**22.4 million renter households** were [cost-burdened](https://www.jchs.harvard.edu/sites/default/files/reports/files/Harvard_JCHS_The_State_of_the_Nations_Housing_2024.pdf){.bg-yellow/60 .highlighted target="_blank"} (spending more than 30 percent of their income on housing costs).',
			annotationClasses:
				'border-yellow bottom-full pb-10 border-r-2 md:border-l-2 left-1/2 -translate-x-[75%] md:translate-x-20 pl-4 md:right-auto md:border-r-0 translate-y-[40px] md:translate-y-[60px]',
			sizeClass: 'h-screen'
		},
		{
			src: 'houses/step-3.png',
			alt: 'Houses filled in with severely cost burdened percentage',
			annotation:
				'A record-high **12.1 million households** were [severely cost-burdened]{.bg-pink-light .highlighted} (paying more than 50 percent of their income on housing costs).',
			annotationClasses:
				'border-pink left-1/3 sm:left-1/2 top-full pt-20 border-l-2 pl-4 md:-translate-x-[120%] sm:-translate-x-[110%] -translate-x-[40%] -translate-y-[100px] sm:-translate-y-[170px]',
			sizeClass: 'h-[150vh]'
		}
	];

	let index: number | undefined = $state();
</script>

<Scroller top={0} threshold={0.5} bottom={1} query=".step" bind:index>
	{#snippet background()}
		<div class="flex h-screen flex-col items-center justify-center">
			<div class="content-well-medium absolute max-h-[calc(100vh-240px)]">
				<Picture {...steps[0]} alt="" class="mx-auto  w-fit" />
				{#each steps as { src, alt, annotation, annotationClasses }, i (i)}
					{#if i <= (index ?? 0) && i !== 0}
						<div transition:fade class="absolute inset-x-4 inset-y-0 md:inset-x-8">
							<Picture {src} {alt} class="mx-auto w-fit" />
						</div>

						{#if i === 1}
							<div
								class="content-well-small label text-gray absolute top-full z-10 translate-y-[90px] bg-white py-4 sm:translate-y-[60px]"
							>
								Source: Joint Center for Housing Studies of Harvard University, The State of the
								Nation's Housing 2024
							</div>
						{/if}

						<div
							transition:fly={{ y: 15 }}
							class={['markdown absolute max-w-3xs text-sm md:text-base', annotationClasses]}
						>
							<div class="overflow-clip rounded-sm bg-white/80">
								{@html md(annotation ?? '')}
							</div>
						</div>
					{/if}
				{/each}
			</div>
		</div>
	{/snippet}

	{#snippet foreground()}
		{#each steps as { sizeClass }, i (i)}
			<div class={['step', sizeClass ?? 'h-screen']}></div>
		{/each}
	{/snippet}
</Scroller>
