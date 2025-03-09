<script lang="ts">
	import { T, Canvas } from '@threlte/core';
	import { Clock } from 'three';
	import fragmentShader from './fragment.glsl?raw';
	import vertexShader from './vertex.glsl?raw';

	import { onMount } from 'svelte';

	let { class: classes = '' } = $props();

	let time = $state(0);
	let width = $state(400);
	let height = $state(400);

	const clock = new Clock();
	const tick = () => {
		time += clock.getDelta();
		requestAnimationFrame(tick);
	};

	onMount(tick);
</script>

<div
	role="application"
	class={['from-black-true/95 to-black-true absolute inset-0 bg-gradient-to-b', classes]}
	bind:clientWidth={width}
	bind:clientHeight={height}
>
	<Canvas>
		<T.Mesh>
			<T.PlaneGeometry args={[2, 2]} />
			<T.ShaderMaterial
				transparent={true}
				{fragmentShader}
				{vertexShader}
				uniforms={{
					uTime: { value: 0 },
					uHeight: { value: 0 },
					uWidth: { value: 0 }
				}}
				uniforms.uTime.value={time}
				uniforms.uHeight.value={height}
				uniforms.uWidth.value={width}
			/>
		</T.Mesh>
	</Canvas>
</div>
