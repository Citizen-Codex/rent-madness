<script lang="ts">
	import Background from '$lib/components/shader/Background.svelte';
	import HouseIcon from '$lib/components/fragments/HouseIcon.svelte';
	import Wordmark from '$lib/components/fragments/Wordmark.svelte';
	import { page } from '$app/state';
</script>

<section class="relative flex h-screen w-full flex-col items-center justify-center overflow-hidden">
	<Background />

	{#each [0, 1, 2] as i (i)}
		<div class="absolute" style:inset={`${-(1 + i) * 20}%`}>
			{#each ['red', 'blue', 'yellow', 'green'] as color (color)}
				<div
					class="absolute inset-0 flex animate-[spin_linear_infinite] items-center justify-center"
					style:animation-duration={`${Math.random() * 100 + 100}s`}
					style:rotate={`${Math.random() * 360}deg`}
				>
					<div class="absolute top-1/12" style:scale={Math.random() * 0.3 + 0.7}>
						<HouseIcon {color} spin class="w-20 rotate-20" />
					</div>
				</div>
			{/each}
		</div>
	{/each}

	<div class="absolute top-8 text-white">
		<Wordmark />
	</div>

	<div class="content-well-medium relative flex flex-col items-center gap-8 text-center">
		<h1 class="py-8 text-8xl font-semibold text-white">{page.data.hed}</h1>
		<p class="subheading border-y border-white p-6 font-medium text-white">{page.data.dek}</p>
		<a href="#explorer" class="cta group flex items-center gap-4 bg-white p-4">
			{page.data['cta-explore']}
			<iconify-icon
				class="text-xl transition-transform group-hover:translate-x-1"
				icon="gridicons:chevron-right"
			></iconify-icon>
		</a>
		<a href="#solutions" class="cta group px-4 text-white">
			{page.data['cta-solutions']}
			<iconify-icon
				class="text-xl transition-transform group-hover:translate-y-1"
				icon="gridicons:chevron-down"
			></iconify-icon>
		</a>
	</div>
</section>
