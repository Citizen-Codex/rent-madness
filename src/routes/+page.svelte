<script lang="ts">
	import Hero from '$lib/components/sections/Hero.svelte';
	import Scrolly from '$lib/components/sections/Scrolly.svelte';

	const { data } = $props();

	$inspect(data);
</script>

<Hero />

<Scrolly />

<section class="h-screen bg-white"></section>
