<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-1'];
</script>

<Section borderTop>
	<div class="content-well-medium flex flex-col items-center gap-10">
		<ChapterNumber>1</ChapterNumber>
		<h2 class="heading max-w-md text-center">{content.hed}</h2>
		<p class="subheading text-center">
			{content.dek}
		</p>
	</div>
	<div>PLACEHOLDER FOR GRAPHIC</div>

	<div class="content-well-small">
		{@html md(content.content)}
	</div>
</Section>
