<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import ChartTooltip from '$lib/components/interactivity/ChartTooltip.svelte';
	import md from '$lib/utils/md';
	import { scaleLinear, max } from 'd3';
	import { formatNumber, formatPercent } from '$lib/utils/format';

	import { page } from '$app/state';

	const content = page.data['chapter-5'];

	const data = [
		{ zip: '85017', neighborhood: 'Maryvale', acs: 922, zori: 1562 },
		{ zip: '85034', neighborhood: 'Sky Harbor Area', acs: 908, zori: 1534 },
		{ zip: '85031', neighborhood: 'Maryvale West', acs: 992, zori: 1494 },
		{ zip: '85041', neighborhood: 'South Mountain', acs: 1128, zori: 1666 },
		{ zip: '85040', neighborhood: 'South Phoenix', acs: 913, zori: 1327 },
		{ zip: '85033', neighborhood: 'Maryvale South', acs: 974, zori: 1405 },
		{ zip: '85003', neighborhood: 'Downtown Phoenix', acs: 1091, zori: 1507 },
		{ zip: '85043', neighborhood: 'Estrella', acs: 1182, zori: 1547 },
		{ zip: '85006', neighborhood: 'Garfield/Eastlake', acs: 898, zori: 1120 },
		{ zip: '85018', neighborhood: 'Arcadia', acs: 1164, zori: 1432 },
		{ zip: '85051', neighborhood: 'North Mountain Village', acs: 956, zori: 1159 },
		{ zip: '85042', neighborhood: 'South Mountain Park', acs: 1139, zori: 1360 },
		{ zip: '85050', neighborhood: 'Desert View', acs: 1795, zori: 2097 },
		{
			zip: '85013',
			neighborhood: 'Central Phoenix/Encanto',
			acs: 1141,
			zori: 1328
		},
		{ zip: '85037', neighborhood: 'West Phoenix', acs: 1227, zori: 1422 },
		{
			zip: '85008',
			neighborhood: 'East Phoenix/Green Gables',
			acs: 1038,
			zori: 1201
		},
		{
			zip: '85032',
			neighborhood: 'Paradise Valley Village',
			acs: 1171,
			zori: 1323
		},
		{ zip: '85035', neighborhood: 'Maryvale East', acs: 1047, zori: 1163 },
		{
			zip: '85004',
			neighborhood: 'Central City/Evans Churchill',
			acs: 1456,
			zori: 1599
		},
		{
			zip: '85016',
			neighborhood: 'Camelback East/Biltmore',
			acs: 1255,
			zori: 1359
		},
		{ zip: '85022', neighborhood: 'Moon Valley', acs: 1179, zori: 1272 },
		{ zip: '85021', neighborhood: 'North Central Phoenix', acs: 973, zori: 1046 },
		{ zip: '85023', neighborhood: 'Deer Valley', acs: 1151, zori: 1233 },
		{ zip: '85015', neighborhood: 'Alhambra', acs: 964, zori: 1013 },
		{ zip: '85027', neighborhood: 'North Phoenix', acs: 1194, zori: 1240 },
		{ zip: '85014', neighborhood: 'Midtown Phoenix', acs: 1153, zori: 1190 },
		{ zip: '85053', neighborhood: 'Northwest Phoenix', acs: 1095, zori: 1125 },
		{ zip: '85085', neighborhood: 'Norterra', acs: 1527, zori: 1565 },
		{ zip: '85020', neighborhood: 'Sunnyslope', acs: 1147, zori: 1173 },
		{
			zip: '85086',
			neighborhood: 'New River/Desert Hills',
			acs: 1761,
			zori: 1774
		},
		{ zip: '85012', neighborhood: 'Central Corridor', acs: 1475, zori: 1412 },
		{ zip: '85044', neighborhood: 'Ahwatukee North', acs: 1462, zori: 1390 },
		{ zip: '85048', neighborhood: 'Ahwatukee South', acs: 1598, zori: 1516 },
		{ zip: '85024', neighborhood: 'Desert Ridge', acs: 1495, zori: 1410 },
		{
			zip: '85054',
			neighborhood: 'Desert Ridge/Mayo Clinic',
			acs: 1823,
			zori: 1685
		},
		{ zip: '85029', neighborhood: 'North Mountain', acs: 1108, zori: 986 },
		{ zip: '85007', neighborhood: 'Capitol District', acs: 827, zori: null },
		{
			zip: '85009',
			neighborhood: 'West Phoenix/Central City',
			acs: 866,
			zori: null
		},
		{ zip: '85019', neighborhood: 'West Phoenix/Maryvale', acs: 987, zori: null },
		{
			zip: '85028',
			neighborhood: 'Paradise Valley/Mountain View',
			acs: 1458,
			zori: null
		},
		{ zip: '85045', neighborhood: 'Ahwatukee Foothills', acs: 1910, zori: null },
		{
			zip: '85083',
			neighborhood: 'Sonoran Desert Preserve',
			acs: 1707,
			zori: null
		}
	];

	const legend = [
		{ color: 'bg-yellow', label: 'Median rent from ACS' },
		{ color: 'bg-orange', label: 'Mean ZORI value' },
		{ color: 'bg-black !h-0.5', label: 'Price disparity' }
	];

	const maxX = max(data, (d) => Math.max(d.acs ?? 0, d.zori ?? 0));

	const xScale = scaleLinear()
		.domain([0, maxX * 1.1])
		.range([0, 100]);

	let hovered = $state<{ id: string; data: (typeof data)[number] }>();
</script>

{#snippet dot(index: number, color: string, left: number)}
	{@const id = `dot-${data[index].zip}-${color}`}
	{@const currentHovered = hovered?.id === id}
	<button
		aria-label={data[index].zip}
		{id}
		class={[
			'absolute h-4 w-4 -translate-x-1/2 cursor-crosshair rounded-full border border-white transition-all hover:scale-125 hover:border-black',
			currentHovered && 'scale-125 !border-black',
			color
		]}
		onclick={() => (hovered = { id, data: data[index] })}
		onblur={() => (hovered = undefined)}
		onpointerenter={() => (hovered = { id, data: data[index] })}
		onpointerleave={() => (hovered = undefined)}
		style:left={`${left}%`}
	></button>
{/snippet}

<Section borderTop id="divergence">
	<div class="content-well-small flex flex-col gap-6 md:gap-10">
		<ChapterNumber>5</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
	</div>

	<div class="content-well-small body">
		{@html md(content['content-before'])}
	</div>

	<div class="content-well-medium">
		<div class="bg-white-true flex flex-col gap-8 rounded-xl border border-black p-4 md:p-8">
			<div class="flex flex-col gap-3">
				<p class="heading-small">Rent Disparities in Phoenix</p>
				<p class="body">
					Looking at the actual rent measures across zip codes, the disparities in prices jump out
					for particular neighborhoods.
				</p>

				<div class="label text-gray flex items-center gap-1">
					<iconify-icon icon="heroicons:cursor-arrow-ripple-solid"></iconify-icon>
					Hover on the dots to see more information
				</div>
			</div>

			<div class="flex flex-wrap justify-center gap-x-4 gap-y-2">
				{#each legend as { color, label } (label)}
					<div class="flex items-center gap-2">
						<div class={['h-3 w-3 rounded-full', color]}></div>
						<p class="label">{label}</p>
					</div>
				{/each}
			</div>

			<div class="flex flex-col gap-4">
				<div
					class="flex max-h-[60vh] overflow-x-hidden overflow-y-auto"
					onscroll={() => (hovered = undefined)}
				>
					<div class="cta-small h-fit w-1/4 border-r-2 border-black">
						{#each data as { neighborhood, zip } (zip)}
							<div class="flex h-10 items-center justify-between gap-2">
								<div class="overflow-hidden">
									<p class="overflow-hidden text-ellipsis whitespace-nowrap">{neighborhood}</p>
									<p class="text-gray text-xs">{zip}</p>
								</div>
								<div class="h-0.5 w-2 bg-black"></div>
							</div>
						{/each}
						<div class="bg-white-true sticky bottom-0 h-6 w-full"></div>
					</div>
					<div class="relative h-fit w-full">
						{#each xScale.ticks(5) as tick (tick)}
							<div
								style:left={`${xScale(tick)}%`}
								class="bg-gray-medium/50 absolute inset-y-0 w-px"
							></div>
						{/each}
						{#each data as { zip, acs, zori }, i (zip)}
							<div class="relative flex h-10 items-center gap-2">
								<div class="bg-gray-medium/50 absolute inset-x-0 h-px"></div>
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

								{#if acs && zori}
									{@const diff = zori - acs}
									{@const position = (xScale(acs) + xScale(zori)) / 2}
									<div
										class="pointer-events-none absolute top-2 -translate-x-1/2 -translate-y-1/2 font-mono text-sm"
										style:left={`${position}%`}
									>
										{formatNumber(diff)}
									</div>
								{/if}
							</div>
						{/each}
						<div class="label bg-white-true sticky bottom-0 -ml-0.5 flex h-6 w-full items-end">
							{#each xScale.ticks(5) as tick (tick)}
								<div style:left={`${xScale(tick)}%`} class="absolute ml-0.5 -translate-x-1/2">
									{formatNumber(tick)}
								</div>
							{/each}
						</div>
					</div>
				</div>
				<div class="label text-gray ml-auto flex w-fit items-center gap-1">
					Rent Price
					<iconify-icon icon="mdi:arrow-right"></iconify-icon>
				</div>
			</div>
		</div>
	</div>

	<div class="content-well-small body">
		{@html md(content['content-after'])}
	</div>
</Section>

{#if hovered}
	<ChartTooltip targetId={hovered?.id} close={() => (hovered = undefined)}>
		<div class="markdown">
			<p>
				<strong>{hovered.data.neighborhood}: {hovered.data.zip}</strong> has {#if hovered.data.zori}a
					mean Zillow Observed Rent Index value of
					<span class="bg-orange-light/40 highlighted font-mono"
						>{formatNumber(hovered.data.zori)}</span
					>
					and
				{/if} a median rent of
				<span class="bg-yellow-light highlighted font-mono">{formatNumber(hovered.data.acs)}</span>
				measured by the American Community Survey.
			</p>
			{#if hovered.data.acs && hovered.data.zori}
				<p>
					The disparity between the two measures is
					<span class="bg-gray-light highlighted font-mono font-bold"
						>{formatPercent((hovered.data.zori - hovered.data.acs) / hovered.data.acs)}</span
					>.
				</p>
			{/if}
		</div>
	</ChartTooltip>
{/if}
