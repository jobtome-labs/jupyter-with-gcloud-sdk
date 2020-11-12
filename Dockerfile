FROM jupyterhub/k8s-singleuser-sample:0.9.0

USER root

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    apt-transport-https \
    curl \
    ca-certificates \
    gcc \
    g++ \
    build-essential \
    python-dev \
    python3-dev \
    gnupg \
    graphviz &&\
    rm -rf /var/lib/apt/lists/*

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
    google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

RUN jupyter nbextension enable --py --sys-prefix qgrid
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# we need to install fbprophet module after the others
RUN pip install fbprophet==0.6
