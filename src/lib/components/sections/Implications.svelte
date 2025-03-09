<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';

	import { page } from '$app/state';

	const content = page.data['chapter-3'];
</script>

<Section>
	<div class="content-well-small flex flex-col gap-10">
		<ChapterNumber>3</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
		<p class="subheading">
			{content.dek}
		</p>
	</div>

	<div class="content-well-small">
		{@html md(content['content-before'])}
	</div>

	<div>PLACEHOLDER FOR GRAPHIC</div>

	<div class="content-well-small">
		{@html md(content['content-after'])}
	</div>
</Section>
