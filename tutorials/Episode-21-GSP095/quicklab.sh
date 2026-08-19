#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP095 - Pub/Sub: Qwik Start - Command Line..."

print_info "🚀 Task 1: Creating Pub/Sub topics..."
gcloud pubsub topics create myTopic
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2

print_info "🗑️ Deleting Test1 and Test2 topics..."
gcloud pubsub topics delete Test1
gcloud pubsub topics delete Test2

print_info "🚀 Task 2: Creating Pub/Sub subscriptions..."
gcloud pubsub subscriptions create --topic myTopic mySubscription
gcloud pubsub subscriptions create --topic myTopic Test1
gcloud pubsub subscriptions create --topic myTopic Test2

print_info "🗑️ Deleting Test1 and Test2 subscriptions..."
gcloud pubsub subscriptions delete Test1
gcloud pubsub subscriptions delete Test2

print_info "🧪 Task 3 & 4: Publishing and pulling messages..."
gcloud pubsub topics publish myTopic --message "Hello"
gcloud pubsub topics publish myTopic --message "Publisher's name is Juni Labs"
gcloud pubsub topics publish myTopic --message "Publisher likes to eat Pizza"
gcloud pubsub topics publish myTopic --message "Publisher thinks Pub/Sub is awesome"

gcloud pubsub subscriptions pull mySubscription --auto-ack

gcloud pubsub topics publish myTopic --message "Publisher is starting to get the hang of Pub/Sub"
gcloud pubsub topics publish myTopic --message "Publisher wonders if all messages will be pulled"
gcloud pubsub topics publish myTopic --message "Publisher will have to test to find out"

gcloud pubsub subscriptions pull mySubscription --limit=3

success "🎉 Lab GSP095 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
