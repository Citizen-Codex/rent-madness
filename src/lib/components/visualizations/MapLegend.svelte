<script lang="ts">
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
</script>

<div
	class="bg-white-true absolute top-16 right-8 flex flex-col border border-black font-mono leading-none tracking-tight uppercase"
>
	<p class="border-b border-black px-4 py-3 font-medium tracking-normal">
		Similarity of price data
	</p>
	<ul class="flex flex-col">
		{#each legend as { color, label, detail } (label)}
			<li class={['max-w-xs px-4 py-3', color]}>
				{label}
				<p class="mt-2 text-sm leading-none normal-case">{detail}</p>
			</li>
		{/each}
	</ul>
</div>
