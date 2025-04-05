<script lang="ts">
	import { page } from '$app/state';
</script>

<svelte:head>
	<title>{page.data.title} - {page.data.publisher}</title>
	<meta name="description" content={page.data.description} />
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	<!-- Preconnect Iconify -->
	<link rel="preconnect" href="https://api.iconify.design" />

	<!-- Open Graph -->
	<meta property="og:locale" content="en_US" />
	<meta property="og:type" content="article" />
	<meta property="og:title" content={page.data.title} />
	<meta property="og:description" content={page.data.description} />
	<meta property="og:url" content={page.data.site_url} />
	<meta property="og:site_name" content={page.data.publisher} />
	<meta property="og:image" content={page.data.image.src} />
	<meta property="og:image:alt" content={page.data.image.alt} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content={page.data.site_url} />
	<meta property="twitter:image" content={page.data.image.large} />
</svelte:head>
