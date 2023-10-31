# Use a Rust base image with the desired Rust environment
FROM rust:latest as builder

# Download and install Julia
RUN mkdir /julia
WORKDIR /julia
# Julia version below works in HASS OS.
#RUN curl -L -o julia.tar.gz https://julialang-s3.julialang.org/bin/musl/x64/1.6/julia-1.6.7-musl-x86_64.tar.gz
# Julia version below works in HASS addon container (Alpine Linux) running in VirtualBOX.
#RUN curl -L -o julia.tar.gz https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.3-linux-x86_64.tar.gz
# Julia version below works in HASS addon container (Alpine Linux) running on Raspberry pi 4.
RUN curl -L -o julia.tar.gz https://julialang-s3.julialang.org/bin/linux/aarch64/1.9/julia-1.9.3-linux-aarch64.tar.gz
RUN tar -xvzf julia.tar.gz
RUN mv julia-* /usr/local/julia
RUN ln -s /usr/local/julia/bin/julia /usr/local/bin/julia

# Create a work directory and move into the directory.
#CMD ["echo", "Create the work directory."]
WORKDIR /app

# Clone the project from GitHub. THIS IS NOT WORKING.
#CMD ["echo", "Clone the github directory."]
#RUN git clone https://github.com/lwarsta/hass_heating_manager.git .

# Copy Rust project files manually from project folder to add-on.
CMD ["echo", "Copy Rust project files manually from project folder to add-on."]
COPY app/Cargo.lock /app/Cargo.lock
COPY app/Cargo.toml /app/Cargo.toml
COPY app/README.md /app/README.md
COPY app/LICENSE /app/LICENSE
RUN mkdir -p /app/src
COPY app/src/main.rs /app/src/main.rs
RUN mkdir -p /app/target

# Copy the Julia script into the container
CMD ["echo", "Copy Julia project files manually from project folder to add-on."]
COPY app/julia/hello_world.jl /app/hello_world.jl

# Build the Rust application
CMD ["echo", "Build the rust application."]
RUN cargo build --release

# Copy the built binary from the builder stage. Currently not needed.
#CMD ["echo", "Copy the executable to the app root folder."]
#COPY --from=builder /app/target/release/heating_manager /app

# Expose the port the Rust server listens on a specific port. IS THIS NEEDED, TEST?
CMD ["echo", "Expose the port. Warning this is hard coded."]
EXPOSE 8000

# Not sure if permissions need to be modified below?
#CMD ["echo", "Change permissions of the executable and start server."]
#RUN chmod a+x /app/heating_manager
#RUN chmod a+x /app/target/release/heating_manager

# Start the application. 
CMD ["echo", "Start the application."]
#CMD ["/app/heating_manager"]
CMD ["/app/target/release/heating_manager"]