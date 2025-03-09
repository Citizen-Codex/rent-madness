<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-6'];
</script>

<Section borderTop background={false}>
	<div class="content-well-large flex flex-col gap-10">
		<ChapterNumber>6</ChapterNumber>
		<div class="flex gap-8">
			<div class="flex max-w-md basis-1/3 flex-col gap-10">
				<h2 class="heading">{content.hed}</h2>
				{@html md(content.content)}
			</div>
			<div class="content-well-large bg-gray-light h-[80vh] basis-2/3 uppercase">
				Placeholder for solutions
			</div>
		</div>
	</div>
</Section>
