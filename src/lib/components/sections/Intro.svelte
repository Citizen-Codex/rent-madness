<script lang="ts">
	import { page } from '$app/state';
	import md from '$lib/utils/md';
	import Section from '$lib/components/fragments/Section.svelte';
	import Houses from '$lib/components/visualizations/Houses.svelte';

	let content = page.data.intro;
</script>

<div class="bg-white">
	<Section id="introduction">
		<div class="content-well-small font-mono tracking-wide uppercase">
			{@html md(content.byline)}
		</div>

		<div class="body content-well-small">
			{@html md(content['content-before'])}
		</div>

		<div class="subheading markdown content-well relative text-center font-light">
			<p>
				<strong>50.4%</strong> of all renter households were
				<span class="bg-yellow highlighted">cost-burdened</span> in 2022.
			</p>
		</div>
	</Section>

	<Houses />

	<Section>
		<div class="body content-well-small">
			{@html md(content['content-after'])}
		</div>
	</Section>
</div>
