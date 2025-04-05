<script lang="ts">
	import { page } from '$app/state';
	import md from '$lib/utils/md';
	import Section from '$lib/components/fragments/Section.svelte';
	import Houses from '$lib/components/visualizations/Houses.svelte';

	let content = page.data.intro;
</script>

<Section id="introduction">
	<div class="content-well-small font-mono tracking-wide uppercase">
		{@html md(content.byline)}
	</div>

	<div class="body content-well-small">
		{@html md(content['content-before'])}
	</div>

	<Houses />

	<div class="body content-well-small">
		{@html md(content['content-after'])}
	</div>
</Section>
