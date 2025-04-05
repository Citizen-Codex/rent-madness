<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import md from '$lib/utils/md';
	import Picture from '$lib/components/media/Picture.svelte';

	import { page } from '$app/state';

	const content = page.data['chapter-1'];
</script>

<Section borderTop id="stakes">
	<div class="content-well-medium flex flex-col items-center gap-10">
		<ChapterNumber>1</ChapterNumber>
		<h2 class="heading max-w-md text-center">{content.hed}</h2>
		<p class="subheading text-center">
			{content.dek}
		</p>
	</div>

	<div class="content-well h-fit">
		<Picture
			src="stakes.png"
			alt="A graphic with a map of Arizona, overlayed with a mid-rise apartment building"
			class="h-full w-full"
		/>
	</div>

	<div class="content-well-small body">
		{@html md(content.content)}
	</div>
</Section>
