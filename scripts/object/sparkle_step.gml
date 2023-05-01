#define sparkle_step

image_index = prevImageIndex;

if (animLoop < 3) {
    if (fc == 3) {
        image_index += 1;
        fc = 0;
        animLoop += 1;
    }
}
if (fc == 4) {
    instance_destroy();
}

fc += 1;

prevImageIndex = image_index;

