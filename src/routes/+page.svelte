<script lang="ts">
	import Menu from '$lib/components/interactivity/Menu.svelte';
	import Hero from '$lib/components/sections/Hero.svelte';
	import Intro from '$lib/components/sections/Intro.svelte';
	import Stakes from '$lib/components/sections/Stakes.svelte';
	import Scrolly from '$lib/components/sections/Scrolly.svelte';
	import Implications from '$lib/components/sections/Implications.svelte';
	import Table from '$lib/components/sections/Table.svelte';
	import Diverge from '$lib/components/sections/Diverge.svelte';
	import Solutions from '$lib/components/sections/Solutions.svelte';
	import Conclusion from '$lib/components/sections/Conclusion.svelte';
	import Acknowledgements from '$lib/components/sections/Acknowledgements.svelte';

	const { data } = $props();

	$inspect(data);
</script>

<Menu />
<Hero />
<Intro />
<Stakes />
<Scrolly />
<Implications />
<Table />
<Diverge />
<Solutions />
<Conclusion />
<Acknowledgements />
