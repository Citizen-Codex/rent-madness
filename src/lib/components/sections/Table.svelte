<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-4'];
</script>

<Section borderTop background={false}>
	<div class="content-well-large flex max-w-2xl flex-col gap-10">
		<ChapterNumber>4</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
		{@html md(content.content)}
	</div>

	<div class="content-well-large uppercase">Placeholder for table</div>
</Section>
