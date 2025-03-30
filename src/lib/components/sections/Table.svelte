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
			icon: 'material-symbols:close',
			bg: 'bg-orange-light/10',
			iconClasses: 'bg-orange text-white'
		},

		{ icon: 'jam:alert', bg: 'bg-yellow-light/80', iconClasses: 'bg-yellow text-black' },
		{ icon: 'mdi:check', bg: 'bg-green-light/10', iconClasses: 'bg-green text-white' }
	];

	const allClosed = Array.from({ length: content.table.rows.length }).fill(false);

	let open = $state(allClosed);
</script>

<Section borderTop background={false} id="types">
	<div class="content-well-large flex max-w-2xl flex-col gap-10">
		<ChapterNumber>4</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
		{@html md(content.content)}
	</div>

	<div class="content-well-large overflow-x-auto lg:overflow-x-visible">
		<table class="table-fixed border-separate border-spacing-0">
			<thead>
				<tr>
					{#each content.table.headers as header, i (header)}
						<th class={['min-w-28', { 'w-1/4 min-w-34': i === 0 }]}>
							<div class="px-6 py-4 text-center font-mono text-lg font-bold">{header}</div>
						</th>
					{/each}
				</tr>
			</thead>
			<tbody>
				{#each content.table.rows as { sources, timeliness, granularity, completeness, availability, detail }, i (sources.title)}
					<tr>
						<td class="h-px !p-0">
							<div class="flex h-full flex-col">
								<div class="border-b border-black bg-white p-4">
									<p class="text-2xl font-bold">{sources.title}</p>
									<p class="text-lg">{sources.examples}</p>
								</div>
								<div class="bg-gray-light flex grow-1 flex-col justify-between gap-6 p-4">
									{@html md(sources.detail)}
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
										>{open[i] ? 'View Less' : 'View More'}
										<iconify-icon
											icon="mdi:chevron-down"
											class={['shrink-0 text-2xl transition-all', open[i] && 'rotate-180']}
										></iconify-icon>
									</button>
								</div>
							</div>
						</td>

						{#each [timeliness, granularity, completeness, availability] as { score, detail }, j (j)}
							<td class={['align-top', scoreParams[score].bg]}>
								<div class="flex flex-col gap-4">
									<IconCircle
										size="sm"
										icon={scoreParams[score].icon}
										class={scoreParams[score].iconClasses}
									/>

									<div class="font-serif text-black">
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
									{detail}
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
		@apply border-t border-l border-black p-4 last:border-r;
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
