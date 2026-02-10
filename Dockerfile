FROM mambaorg/micromamba:1.5.10

LABEL maintainer="sahuno"
LABEL description="tldr - Transposons from Long DNA Reads (Nanopore/PacBio)"
LABEL version="1.3.0"

# Set working directory
WORKDIR /opt/tldr

# Copy environment file first for better layer caching
COPY tldr.yml /opt/tldr/

# Install conda environment
USER root
RUN micromamba install -y -n base -f /opt/tldr/tldr.yml && \
    micromamba clean --all --yes

# Copy application files
COPY setup.py /opt/tldr/
COPY tldr/ /opt/tldr/tldr/
COPY scripts/ /opt/tldr/scripts/
COPY ref/ /opt/tldr/ref/

# Install tldr in editable mode
RUN micromamba run -n base pip install -e /opt/tldr

# Set environment variables for reference data
ENV TLDR_REF_DIR=/opt/tldr/ref
ENV TLDR_REF_HUMAN=/opt/tldr/ref/teref.ont.human.fa
ENV TLDR_REF_MOUSE=/opt/tldr/ref/teref.mouse.fa

# Create data directory for mounting user data
RUN mkdir -p /data && chmod 777 /data

WORKDIR /data

# Set entrypoint to use micromamba
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]

# Default command shows help
CMD ["tldr", "-h"]
