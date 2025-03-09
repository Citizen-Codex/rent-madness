<script lang="ts">
	import { page } from '$app/state';
	import md from '$lib/utils/md';
	import Section from '$lib/components/fragments/Section.svelte';

	let content = page.data.intro;
</script>

<Section>
	<p class="content-well-small font-mono tracking-wide uppercase">
		{@html md(content.byline)}
	</p>

	<p class="body content-well-small">
		{@html md(content['content-before'])}
	</p>

	<div>PLACEHOLDER FOR GRAPHIC</div>

	<div class="body content-well-small">
		{@html md(content['content-after'])}
	</div>
</Section>
