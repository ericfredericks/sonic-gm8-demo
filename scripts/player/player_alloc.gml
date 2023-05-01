#define player_alloc

cpz_dez_128px_mappings = buffer_create();
if (!buffer_read_from_file(
    cpz_dez_128px_mappings,
    "rodata/cpz_dez_128px_mappings.bin")) {
    buffer_destroy(cpz_dez_128px_mappings);
    show_message("Http Dll: Error");
    exit;
}
cpz_dez_16px_collision_index_a = buffer_create();
if (!buffer_read_from_file(
    cpz_dez_16px_collision_index_a,
    "rodata/cpz_dez_16px_collision_index_a.bin")) {
    buffer_destroy(cpz_dez_16px_collision_index_a);
    show_message("Http Dll: Error");
    exit;
}
cpz_dez_16px_collision_index_b = buffer_create();
if (!buffer_read_from_file(
    cpz_dez_16px_collision_index_b,
    "rodata/cpz_dez_16px_collision_index_b.bin")) {
    buffer_destroy(cpz_dez_16px_collision_index_b);
    show_message("Http Dll: Error");
    exit;
}
collision_array_1 = buffer_create();
if (!buffer_read_from_file(
    collision_array_1,
    "rodata/collision_array_1.bin")) {
    buffer_destroy(collision_array_1);
    show_message("Http Dll: Error");
    exit;
}
collision_array_2 = buffer_create();
if (!buffer_read_from_file(
    collision_array_2,
    "rodata/collision_array_2.bin")) {
    buffer_destroy(collision_array_2);
    show_message("Http Dll: Error");
    exit;
}
curve_and_resistance_mapping = buffer_create();
if (!buffer_read_from_file(
    curve_and_resistance_mapping,
    "rodata/curve_and_resistance_mapping.bin")) {
    buffer_destroy(curve_and_resistance_mapping);
    show_message("Http Dll: Error");
    exit;
}

