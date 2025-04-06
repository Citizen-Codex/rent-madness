<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import IconCircle from '$lib/components/fragments/IconCircle.svelte';
	import md from '$lib/utils/md';
	import { slide } from 'svelte/transition';
	import { ScrollTrigger } from 'gsap/ScrollTrigger';

	import { page } from '$app/state';

	const content = page.data['chapter-6'];

	const colors = ['green', 'blue', 'pink', 'orange'];
	const text = ['!text-white', 'text-black', 'text-black', 'text-black'];
	const allClosed = Array.from({ length: content.solutions.length }).fill(false);

	let open = $state(allClosed);
	open[0] = true;
</script>

<Section borderTop background={false} id="solutions" class="justify-center">
	<div class="content-well-small lg:content-well-large flex flex-col gap-6 md:gap-10">
		<ChapterNumber>6</ChapterNumber>
		<div class="flex flex-col gap-10 lg:flex-row lg:gap-16">
			<div class="flex basis-1/3 flex-col gap-6 md:gap-10 lg:max-w-md">
				<h2 class="heading">{content.hed}</h2>
				<div class="body">
					{@html md(content.content)}
				</div>
			</div>
			<div class="flex basis-2/3 flex-col gap-6">
				{#each content.solutions as { summary, detail }, i (i)}
					<div>
						<button
							onclick={() => {
								if (open[i]) {
									open = allClosed;
								} else {
									open = allClosed;
									open[i] = true;
								}
								setTimeout(() => {
									ScrollTrigger.refresh();
								}, 300);
							}}
							style={open[i] && `background-color: var(--color-${colors[i]});`}
							class={[
								'bg-white-true relative z-10 flex w-full items-center gap-6 rounded border border-black px-6 py-4 transition-colors',
								open[i] && text[i]
							]}
						>
							<span class="heading font-medium">{i + 1}</span>
							<p class="subheading text-left">{summary}</p>
							<IconCircle
								icon="mdi:chevron-down"
								class={[
									'ml-auto flex h-10 w-10 shrink-0 items-center justify-center rounded-full text-2xl transition-all',
									open[i] ? 'bg-white-true rotate-180 text-black' : 'text-white'
								]}
								style={!open[i] && `background-color: var(--color-${colors[i]});`}
								size="md"
							/>
						</button>
						{#if open[i]}
							<div transition:slide class="body -mt-1 border border-black p-6">
								{@html md(detail)}
							</div>
						{/if}
					</div>
				{/each}
			</div>
		</div>
	</div>
</Section>
