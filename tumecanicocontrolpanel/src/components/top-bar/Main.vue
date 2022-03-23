<template>
  <!-- BEGIN: Top Bar -->
  <div
    class="top-bar-boxed border-b border-theme-2 -mt-7 md:-mt-5 -mx-3 sm:-mx-8 px-3 sm:px-8 md:pt-0 mb-12"
  >
    <div class="h-full flex items-center">
      <!-- BEGIN: Logo -->
      <a href="" class="-intro-x hidden md:flex">
        <div class="w-12 h-12 image-fit">
          <img
            alt="Logo"
            class="rounded-full"
            style="background-color:white; object-fit: contain;"
            src="@/assets/images/tumecanico.png"
          />
        </div>
        <span class="text-white text-lg ml-3" style="align-self: center;">
          Tu Mecánico<span class="font-medium"> En Línea</span>
        </span>
      </a>
    </div>
  </div>
  <!-- END: Top Bar -->
</template>

<script>
import { defineComponent, ref } from 'vue'

export default defineComponent({
  setup() {
    const searchDropdown = ref(false)

    const showSearchDropdown = () => {
      searchDropdown.value = true
    }

    const hideSearchDropdown = () => {
      searchDropdown.value = false
    }

    return {
      searchDropdown,
      showSearchDropdown,
      hideSearchDropdown
    }
  }
})
</script>
