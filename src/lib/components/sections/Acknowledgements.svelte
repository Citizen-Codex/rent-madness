<script lang="ts">
	import Section from '$lib/components/fragments/Section.svelte';
	import { page } from '$app/state';
	import md from '$lib/utils/md';

	const content = page.data['acknowledgments'];
</script>

<Section borderTop id="acknowledgments">
	<div class="content-well-small flex flex-col gap-6 md:gap-10">
		<h2 class="heading-small">About the Story</h2>
		<div class="body">
			{@html md(content.content)}
		</div>
	</div>
</Section>
