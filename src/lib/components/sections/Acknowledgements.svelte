<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import { page } from '$app/state';
	import md from '$lib/utils/md';

	const sections = page.data['acknowledgments'];
</script>

<Section borderTop id="acknowledgments">
	<div class="content-well-small flex flex-col gap-6 md:gap-10">
		{#each sections as { subheading, content }, i (i)}
			<div>
				<p class="cta mb-4">{subheading}</p>
				<div class="cta-small text-gray leading-tight normal-case">
					{@html md(content)}
				</div>
			</div>
		{/each}
	</div>
</Section>
