<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import Background from '$lib/components/shader/Background.svelte';
	import HouseIcon from '$lib/components/fragments/HouseIcon.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-7'];
	const colors = ['green', 'blue', 'yellow', 'orange'];
</script>

<Section borderTop padding={false} id="conclusion">
	<div class="flex">
		<div
			class="bg-gray-light relative flex min-h-[60vh] basis-1/2 items-center justify-center overflow-hidden"
		>
			<Background />
			<div class="pointer-events-none relative">
				<HouseIcon color="orange" class="w-28 rotate-20" spin />
				{#each [0, 1] as i (i)}
					<div class="absolute" style:inset={`${-(2 + i) * 75}%`}>
						{#each [0, 1] as j (j)}
							{@const color = colors[Math.floor(Math.random() * colors.length)]}
							<div
								class="absolute inset-0 flex animate-[spin_linear_infinite] items-center justify-center"
								style:animation-duration={`${Math.random() * 100 + 100}s`}
								style:rotate={`${Math.random() * 360}deg`}
							>
								<div class="absolute top-0" style:scale={Math.random() * 0.3 + 0.7}>
									<HouseIcon {color} spin class="w-20 rotate-20" />
								</div>
							</div>
						{/each}
					</div>
				{/each}
			</div>
		</div>
		<div class="flex basis-1/2 flex-col justify-center gap-10 px-8 py-16 md:px-16">
			<ChapterNumber>7</ChapterNumber>
			<h2 class="heading">{content.hed}</h2>
			<div class="body">
				{@html md(content.content)}
			</div>
		</div>
	</div>
</Section>
