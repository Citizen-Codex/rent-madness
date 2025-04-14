<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import IconCircle from '$lib/components/fragments/IconCircle.svelte';
	import md from '$lib/utils/md';
	import { slide } from 'svelte/transition';

	import { page } from '$app/state';

	const content = page.data['chapter-4'];

	const scoreParams = [
		{
			label: 'Poor',
			icon: 'material-symbols:close',
			bg: 'bg-orange-light/10',
			iconClasses: 'bg-orange text-white'
		},

		{
			label: 'Fair',
			icon: 'jam:alert',
			bg: 'bg-yellow-light/80',
			iconClasses: 'bg-yellow text-black'
		},
		{
			label: 'Good',
			icon: 'mdi:check',
			bg: 'bg-green-light/10',
			iconClasses: 'bg-green text-white'
		}
	];

	const headerIcons = {
		Timeliness: 'material-symbols:event-available',
		'Geographic Granularity': 'gis:map',
		'Sample Completeness': 'material-symbols-light:incomplete-circle',
		Availability: 'material-symbols:key'
	};

	const allClosed = Array.from({ length: content.table.rows.length }).fill(false);

	let open = $state(allClosed);
</script>

{#snippet more(i: number)}
	<button
		class="cta-small flex cursor-pointer items-center gap-2"
		onclick={() => {
			if (open[i]) {
				open = allClosed;
			} else {
				open = allClosed;
				open[i] = true;
			}
		}}
		>{open[i] ? 'Hide' : 'Learn More'}
		<iconify-icon
			icon="mdi:chevron-down"
			class={['shrink-0 text-2xl transition-all', open[i] && 'rotate-180']}
		></iconify-icon>
	</button>
{/snippet}

<Section borderTop background={false} id="types">
	<div class="content-well-large flex max-w-2xl flex-col gap-6 md:gap-10">
		<ChapterNumber>4</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
		<div class="body">
			{@html md(content.content)}
		</div>
	</div>

	<div class="content-well-large overflow-x-auto lg:overflow-x-visible">
		<table class="border-separate border-spacing-0">
			<thead>
				<tr>
					{#each content.table.headers as header, i (header)}
						{@const headerIcon = headerIcons[header]}
						<th class={['w-full lg:w-auto lg:min-w-28', { 'lg:w-1/4 lg:min-w-34': i === 0 }]}>
							<div class="p-2 text-center font-mono text-lg font-bold md:px-6 md:py-4">
								<span class="hidden lg:inline">{header}</span>
								{#if headerIcon}
									<iconify-icon icon={headerIcon} class="text-2xl lg:hidden"></iconify-icon>
								{:else}
									<span class="lg:hidden">{header}</span>
								{/if}
							</div>
						</th>
					{/each}
				</tr>
			</thead>
			<tbody>
				{#each content.table.rows as { sources, timeliness, granularity, completeness, availability, detail }, i (sources.title)}
					<tr>
						<td class="h-px !p-0">
							<div class="flex h-full flex-col">
								<div
									class="flex grow-1 flex-col border-black bg-white p-3 md:p-4 lg:grow-0 lg:border-b"
								>
									<p class="text-lg leading-tight font-bold md:text-xl lg:text-2xl">
										{sources.title}
									</p>
									<p class="hidden text-lg lg:block">{sources.examples}</p>
									<div class="mt-4 lg:hidden">
										{@render more(i)}
									</div>
								</div>
								<div class="bg-gray-light hidden grow-1 flex-col justify-between gap-6 p-4 lg:flex">
									{@html md(sources.detail)}
									{@render more(i)}
								</div>
							</div>
						</td>

						{#each [timeliness, granularity, completeness, availability] as { score, detail }, j (j)}
							<td class={['lg:align-top', scoreParams[score].bg]}>
								<div class="flex flex-col items-center gap-4">
									<IconCircle
										size="sm"
										icon={scoreParams[score].icon}
										class={scoreParams[score].iconClasses}
									/>

									<div class="hidden font-serif text-black lg:block">
										{@html md(detail)}
									</div>
								</div>
							</td>
						{/each}
					</tr>
					{#if open[i]}
						<tr>
							<td colspan="5" class="!p-0 text-left">
								<div transition:slide class="p-8">
									<div class="text-gray-dark text-sm md:text-base">
										<div class="mb-4 lg:hidden">
											{@html md(sources.detail)}
										</div>
										{detail}
									</div>
									<div class="mt-6 flex flex-col gap-6 lg:hidden">
										{#each [timeliness, granularity, completeness, availability] as { score, detail }, j (j)}
											{@const scoreObj = scoreParams[score]}
											<div>
												<p class="mb-2 font-bold">
													{Object.keys(headerIcons)[j]}:
													<span class={['highlighted font-normal', scoreObj.iconClasses]}
														>{scoreObj.label}</span
													>
												</p>
												<div class="text-gray-dark font-serif text-sm">
													{@html md(detail)}
												</div>
											</div>
										{/each}
									</div>
								</div>
							</td>
						</tr>
					{/if}
				{/each}
			</tbody>
		</table>
	</div>
</Section>

<style lang="postcss">
	@reference '$lib/styles/app.css';

	td {
		@apply border-t border-l border-black px-3 last:border-r md:p-4;
	}

	tr:last-child td {
		@apply border-b;
	}

	th {
		@apply bg-white-true sticky top-0 z-10 h-px border-b pt-4;

		div {
			@apply flex h-full items-center justify-center border-t border-l;
		}
	}

	th:first-child > div {
		@apply rounded-tl-2xl;
	}

	th:last-child > div {
		@apply rounded-tr-2xl border-r;
	}
</style>
