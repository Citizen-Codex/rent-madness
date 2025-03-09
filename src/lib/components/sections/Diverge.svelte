<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-5'];
</script>

<Section borderTop>
	<div class="content-well-small flex flex-col gap-10">
		<ChapterNumber>5</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
	</div>

	<div class="content-well-small">
		{@html md(content['content-before'])}
	</div>

	<div>PLACEHOLDER FOR GRAPHIC</div>

	<div class="content-well-small">
		{@html md(content['content-after'])}
	</div>
</Section>
