<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import ChartTooltip from '$lib/components/interactivity/ChartTooltip.svelte';
	import md from '$lib/utils/md';
	import { scaleLinear, max, format } from 'd3';

	import { page } from '$app/state';

	const content = page.data['chapter-5'];

	const data = [
		{ name: '85017', acs: 922, zori: 1562 },
		{ name: '85034', acs: 908, zori: 1534 },
		{ name: '85031', acs: 992, zori: 1494 },
		{ name: '85041', acs: 1128, zori: 1666 },
		{ name: '85040', acs: 913, zori: 1327 },
		{ name: '85033', acs: 974, zori: 1405 },
		{ name: '85003', acs: 1091, zori: 1507 },
		{ name: '85043', acs: 1182, zori: 1547 },
		{ name: '85006', acs: 898, zori: 1120 },
		{ name: '85018', acs: 1164, zori: 1432 },
		{ name: '85051', acs: 956, zori: 1159 },
		{ name: '85042', acs: 1139, zori: 1360 },
		{ name: '85050', acs: 1795, zori: 2097 },
		{ name: '85013', acs: 1141, zori: 1328 },
		{ name: '85037', acs: 1227, zori: 1422 },
		{ name: '85008', acs: 1038, zori: 1201 },
		{ name: '85032', acs: 1171, zori: 1323 },
		{ name: '85035', acs: 1047, zori: 1163 },
		{ name: '85004', acs: 1456, zori: 1599 },
		{ name: '85016', acs: 1255, zori: 1359 },
		{ name: '85022', acs: 1179, zori: 1272 },
		{ name: '85021', acs: 973, zori: 1046 },
		{ name: '85023', acs: 1151, zori: 1233 },
		{ name: '85015', acs: 964, zori: 1013 },
		{ name: '85027', acs: 1194, zori: 1240 },
		{ name: '85014', acs: 1153, zori: 1190 },
		{ name: '85053', acs: 1095, zori: 1125 },
		{ name: '85085', acs: 1527, zori: 1565 },
		{ name: '85020', acs: 1147, zori: 1173 },
		{ name: '85086', acs: 1761, zori: 1774 },
		{ name: '85012', acs: 1475, zori: 1412 },
		{ name: '85044', acs: 1462, zori: 1390 },
		{ name: '85048', acs: 1598, zori: 1516 },
		{ name: '85024', acs: 1495, zori: 1410 },
		{ name: '85054', acs: 1823, zori: 1685 },
		{ name: '85029', acs: 1108, zori: 986 },
		{ name: '85007', acs: 827, zori: null },
		{ name: '85009', acs: 866, zori: null },
		{ name: '85019', acs: 987, zori: null },
		{ name: '85028', acs: 1458, zori: null },
		{ name: '85045', acs: 1910, zori: null },
		{ name: '85083', acs: 1707, zori: null }
	];

	const legend = [
		{ color: 'bg-yellow', label: 'Median rent from ACS' },
		{ color: 'bg-orange', label: 'Mean ZORI value' }
	];

	const maxX = max(data, (d) => Math.max(d.acs ?? 0, d.zori ?? 0));

	const xScale = scaleLinear()
		.domain([0, maxX * 1.1])
		.range([0, 100]);

	let hovered = $state<{ id: string; data: (typeof data)[number] }>();

	const formatNumber = format('$,.0f');
</script>

{#snippet dot(index: number, color: string, left: number)}
	{@const id = `dot-${data[index].name}-${color}`}
	<div
		{id}
		class={[
			'absolute h-3 w-3 -translate-x-1/2 cursor-crosshair rounded-full border border-white transition-all hover:scale-110 hover:border-black',
			color
		]}
		onpointerenter={() => (hovered = { id, data: data[index] })}
		onpointerleave={() => (hovered = undefined)}
		style:left={`${left}%`}
	></div>
{/snippet}

<Section borderTop id="divergence">
	<div class="content-well-small flex flex-col gap-10">
		<ChapterNumber>5</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
	</div>

	<div class="content-well-small">
		{@html md(content['content-before'])}
	</div>

	<div class="content-well-medium flex flex-col gap-8">
		<div class="flex flex-col gap-3">
			<p class="heading-small">Rent Disparities in Phoenix</p>
			<p class="subheading">
				Looking at the actual rent measures across zip codes, the disparities in prices jump out for
				particular neighborhoods.
			</p>
		</div>

		<div class="flex flex-wrap gap-x-4 gap-y-2">
			{#each legend as { color, label } (label)}
				<div class="flex items-center gap-1">
					<div class={['h-3 w-3 rounded-full', color]}></div>
					<p class="label">{label}</p>
				</div>
			{/each}
		</div>

		<div class="flex max-h-[60vh] overflow-x-hidden overflow-y-auto">
			<div class="cta-small h-fit w-18 border-r-2 border-black">
				{#each data as { name } (name)}
					<div class="flex h-6 items-center justify-between gap-2">
						<p>{name}</p>
						<div class="h-0.5 w-2 bg-black"></div>
					</div>
				{/each}
				<div class="sticky bottom-0 h-6 w-full bg-white"></div>
			</div>
			<div class="relative h-fit w-full">
				{#each xScale.ticks(5) as tick (tick)}
					<div
						style:left={`${xScale(tick)}%`}
						class="bg-gray-medium absolute inset-y-0 w-[0.5px]"
					></div>
				{/each}
				{#each data as { name, acs, zori }, i (name)}
					<div class="relative flex h-6 items-center gap-2">
						<div class="bg-gray-medium absolute inset-x-0 h-[0.5px]"></div>
						{#if acs && zori}
							<div
								class="bg-gray absolute h-px"
								style:left={`${xScale(Math.min(acs, zori))}%`}
								style:right={`${100 - xScale(Math.max(acs, zori))}%`}
							></div>
						{/if}
						{#if acs}
							{@render dot(i, 'bg-yellow', xScale(acs))}
						{/if}
						{#if zori}
							{@render dot(i, 'bg-orange', xScale(zori))}
						{/if}
					</div>
				{/each}
				<div class="label sticky bottom-0 -ml-0.5 flex h-6 w-full items-end bg-white">
					{#each xScale.ticks(5) as tick (tick)}
						<div style:left={`${xScale(tick)}%`} class="absolute ml-0.5 -translate-x-1/2">
							{formatNumber(tick)}
						</div>
					{/each}
				</div>
			</div>
		</div>
	</div>

	<div class="content-well-small">
		{@html md(content['content-after'])}
	</div>
</Section>

{#if hovered}
	<ChartTooltip targetId={hovered?.id}>
		<div class="markdown">
			<p>
				<strong>{hovered.data.name}</strong> has {#if hovered.data.zori}a mean Zillow Observed Rent
					Index value of
					<span class="bg-orange-light/40 highlighted font-mono"
						>{formatNumber(hovered.data.zori)}</span
					>
					and
				{/if} median rent of
				<span class="bg-yellow-light highlighted font-mono">{formatNumber(hovered.data.acs)}</span>
				measured by the American Community Survey.
			</p>
			{#if hovered.data.acs && hovered.data.zori}
				<p>
					The disparity between the two measures is
					<span class="bg-gray-light highlighted font-mono font-bold"
						>{format('.0%')((hovered.data.zori - hovered.data.acs) / hovered.data.acs)}</span
					>.
				</p>
			{/if}
		</div>
	</ChartTooltip>
{/if}
