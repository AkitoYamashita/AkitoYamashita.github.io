<template>
<div class="area">
	<button @click="count++">Click</button> -&gt; Count: {{ count }}
</div>
</template>

<script setup>
import { ref } from 'vue';
const count = ref(0)
</script>

<style lang="scss" scoped>
.area{
	border:1px solid gray;
	padding:5px;
}
</style>