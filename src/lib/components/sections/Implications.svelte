<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import ChapterNumber from '$lib/components/fragments/ChapterNumber.svelte';
	import line from '$lib/assets/figma2html/line.html?raw';
	import md from '$lib/utils/md';
	import { setupFigma2Html } from '$lib/utils/figma2html';
	import { onMount } from 'svelte';

	import { page } from '$app/state';

	const content = page.data['chapter-3'];

	onMount(() => {
		setupFigma2Html('line-box');
	});
</script>

<Section id="implications">
	<div class="content-well-small flex flex-col gap-6 md:gap-10">
		<ChapterNumber>3</ChapterNumber>
		<h2 class="heading">{content.hed}</h2>
		<p class="subheading">
			{content.dek}
		</p>
	</div>

	<div class="content-well-small body">
		{@html md(content['content-before'])}
	</div>

	<div class="content-well-small !max-w-2xl">
		<div class="overflow-hidden rounded-lg border border-black">
			{@html line}
		</div>
	</div>

	<div class="content-well-small body">
		{@html md(content['content-after'])}
	</div>
</Section>
