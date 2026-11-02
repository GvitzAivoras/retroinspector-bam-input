def get_existing_bam(wc):
    try:
        return config["samples"][wc.sample]
    except KeyError:
        raise ValueError(
            f"No existing BAM defined for sample '{wc.sample}'"
        )

def get_existing_bai(wc):
    bam = get_existing_bam(wc)

    candidates = [
        bam + ".bai",                 # sample.bam.bai
        bam.replace(".bam", ".bai"),  # sample.bai
    ]

    for bai in candidates:
        if os.path.exists(bai):
            return bai

    raise ValueError(
        f"No BAM index found for {bam}. "
        f"Tried: {', '.join(candidates)}"
    )




rule link_existing_bam:
    input:
        bam=get_existing_bam,
        bai=get_existing_bai
    output:
        bam="alns/{sample}.bam",
        bai="alns/{sample}.bam.bai"
    shell:
        """
        ln -sf {input.bam} {output.bam}
        ln -sf {input.bai} {output.bai}
        """

