out/game.gba: target/thumbv4t-none-eabi/release/rust-on-gba.gba
	mkdir -p out
	cp $< $@

target/thumbv4t-none-eabi/release/rust-on-gba.gba: target/thumbv4t-none-eabi/release/rust-on-gba.elf
	arm-none-eabi-objcopy -O binary $< $@
	gbafix $@

target/thumbv4t-none-eabi/release/rust-on-gba.elf: target/thumbv4t-none-eabi/release/rust-on-gba
	cp $< $@

target/thumbv4t-none-eabi/release/rust-on-gba:
	cargo build --release

clean:
	cargo clean
	-rm out -rf

.PHONY: target/thumbv4t-none-eabi/release/rust-on-gba clean
