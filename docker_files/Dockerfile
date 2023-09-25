# Base Image
FROM continuumio/miniconda3:4.6.14
LABEL authors="Xiandong Meng" \
      description="Tree Figure Drawing Tool" \
      software.name="FigTree v1.4.4, 2006-2018" \
      software.description="" \
      software.website="http://tree.bio.ed.ac.uk/" \
      container.category="tool"

# Update conda to latest version.
RUN conda update -n base -c defaults conda

RUN conda config --env --append channels anaconda
RUN conda config --env --append channels conda-forge
RUN conda config --env --append channels bioconda

# Install software

RUN conda install -y figtree=1.4.4 pdftotext pdftopng

RUN mkdir -p /work
WORKDIR /work

COPY . .
