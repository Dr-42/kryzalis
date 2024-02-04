ENTRY(_start)

SECTIONS
{
	. = 1M;

	.boot :
	{
		KEEP(*(.multiboot_header))
	}

	.data :
	{
		*(.data)
	}

	.rodata :
	{
		*(.rodata)
	}

	.text :
	{
		*(.text)
	}

	.bss :
	{
		*(.bss)
	}
}
