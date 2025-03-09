<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-7'];
</script>

<Section borderTop padding={false}>
	<div class="flex">
		<div class="content-well-large bg-gray-light h-[80vh] basis-1/2 uppercase">
			Placeholder for graphic
		</div>
		<div class="flex basis-1/2 flex-col gap-10 px-8 py-16 md:px-16">
			<ChapterNumber>7</ChapterNumber>
			<h2 class="heading">{content.hed}</h2>
			{@html md(content.content)}
		</div>
	</div>
</Section>
