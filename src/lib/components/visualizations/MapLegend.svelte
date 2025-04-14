<script lang="ts">
	import { slide, fly } from 'svelte/transition';

	const legend = [
		{
			color: 'bg-map-1/70',
			label: 'Similar',
			detail: 'The data sources are within a reasonable range of each other, plus or minus 30%.'
		},
		{
			color: 'bg-map-2/70',
			label: 'Dissimilar',
			detail: 'The ZORI price index is up to 100% above the ACS data.'
		},
		{
			color: 'bg-map-3/70',
			label: 'Very Dissimilar',
			detail: 'The ZORI price index is up to 200% above the ACS data.'
		},
		{
			color: 'bg-map-4/70 text-white',
			label: 'Extremely Dissimilar',
			detail: 'The ZORI price index is more than 200% above the ACS data.'
		},
		{
			color: 'bg-map-5/70',
			label: 'One Data Source Available',
			detail: 'One of the data sources is unavailable, so no comparison can be made.'
		},
		{
			color: 'bg-map-6/70',
			label: 'No Data Available',
			detail: 'Neither data source is available.'
		}
	];

	let collapsed = $state(true);
</script>

<div
	class={[
		'bg-white-true absolute top-4 right-0 flex w-[280px] flex-col border border-black font-mono text-sm leading-none tracking-tight uppercase sm:right-4 '
	]}
	transition:fly={{ x: '100%', duration: 300 }}
>
	<button
		onclick={() => (collapsed = !collapsed)}
		class="pointer-events-auto flex items-center justify-between border-b border-black px-4 py-3 font-medium tracking-normal uppercase"
	>
		Similarity of price data
		<iconify-icon
			icon="mdi:chevron-down"
			class={['text-xl text-black transition-transform', !collapsed && 'rotate-180']}
		></iconify-icon>
	</button>
	<ul class={['flex flex-col']}>
		{#each legend as { color, label, detail } (label)}
			<li class={['px-4 transition-all', color, collapsed ? 'py-2' : 'py-3']}>
				{label}
				{#if !collapsed}
					<p transition:slide class="mt-2 text-xs leading-none normal-case">{detail}</p>
				{/if}
			</li>
		{/each}
	</ul>
</div>
