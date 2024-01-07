<template>
<div>
	<p class="label">{{ count }}回クリックしました</p>
	<button @click="count++">ここをクリック！</button>
</div>
</template>

<script setup>
import { ref } from 'vue';

const count = ref(0)
</script>

<style lang="scss" scoped>
.label {
	color: red;
}
</style>