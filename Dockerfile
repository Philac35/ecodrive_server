# Stage 1: Build the Flutter web app
FROM instrumentisto/flutter:latest AS builder
LABEL Name=ecodriveserver Version=0.0.1 

# Create a non-root user and group
RUN addgroup --gid 1001 newgroup && \
    adduser --disabled-password --gecos '' --uid 1001 --gid 1001 newuser

# Change ownership of the Flutter SDK directory to the non-root user and group
RUN chown -R newuser:newgroup /usr/local/flutter

WORKDIR /app

# Copy only pubspec files and get dependencies (improves build cache)
COPY pubspec.yaml pubspec.lock ./

# Ensure the pubspec.lock file has the correct permissions
RUN chmod 644 pubspec.lock

# Ensure the working directory has the correct permissions
RUN chown -R newuser:newgroup /app

# Switch to the non-root user
USER newuser

# Configure Git to trust the Flutter directory
RUN git config --global --add safe.directory /usr/local/flutter

# Get dependencies
RUN flutter pub get

# Switch back to root to copy the rest of the source code
USER root

# Copy the rest of the source code
COPY . .

RUN chown -R newuser:newgroup /app

# Ensure the build directory exists and is owned by the non-root user
RUN mkdir -p /app/build && chown -R newuser:newgroup /app/build

# Switch back to the non-root user for the build process
USER newuser

# Ensure web support is enabled
RUN flutter config --enable-web

# Clean old builds and fetch dependencies
RUN flutter clean
RUN flutter pub get

# Build the web app (release mode)
RUN flutter build web --release

#To load image
RUN ls -al /app/build/web/assets

# Stage 2: Serve with Nginx (Not needed in development)
FROM nginx:alpine

# Copy built web assets to nginx html directory
COPY --from=builder /app/build/web /usr/share/nginx/html
# You can comment these above lines for development

# Record the exposed port
EXPOSE 80

# Set the default command (adjust as needed)
# In development:
# CMD ["flutter", "run", "-d", "web-server", "--web-port", "8000"]
# In Production:
CMD ["nginx", "-g", "daemon off;"]
 