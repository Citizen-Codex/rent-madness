<script lang="ts">
	interface Props {
		icon: string;
		iconClass?: string;
		class?: string;
	}

	const { icon, iconClass, class: classes }: Props = $props();
</script>

<div class={['flex h-12 w-12 items-center justify-center rounded-full', classes]}>
	<iconify-icon {icon} class={[iconClass]}></iconify-icon>
</div>
