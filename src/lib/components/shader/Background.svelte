<script lang="ts">
	import { T, Canvas } from '@threlte/core';
	import { Clock } from 'three';
	import fragmentShader from './fragment.glsl?raw';
	import vertexShader from './vertex.glsl?raw';

	import { onMount } from 'svelte';

	let { class: classes = '' } = $props();

	const SENSITIVITY = 0.3;
	let time = $state(0);
	let width = $state(400);
	let height = $state(400);
	let mouse = $state({ x: 0, y: 0 });

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
	onmousemove={(e) => {
		mouse.x = e.clientX / width;
		mouse.y = e.clientY / height;
	}}
>
	<Canvas>
		<T.PerspectiveCamera
			makeDefault
			fov={10}
			position={[0, 0, 5]}
			aspect={width / height}
			near={0.001}
			far={10}
		/>
		<T.Mesh
			rotation={[(mouse.y - 0.5) * SENSITIVITY, (mouse.x - 0.5) * SENSITIVITY, 0]}
			position={[(mouse.x - 0.5) * SENSITIVITY * 0.2, -(mouse.y - 0.5) * SENSITIVITY * 0.2, 0]}
		>
			<T.PlaneGeometry args={[width / height, 1, 1, 1]} />
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
