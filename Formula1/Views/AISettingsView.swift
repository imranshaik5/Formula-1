import SwiftUI

struct AISettingsView: View {
    @EnvironmentObject private var configStore: AIConfigStore
    @Environment(\.dismiss) private var dismiss

    @State private var endpoint: String = ""
    @State private var apiKey: String = ""
    @State private var model: String = ""
    @State private var showKey = false
    @State private var saved = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Endpoint URL", text: $endpoint)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(.subheadline, design: .monospaced))
                    HStack {
                        if showKey {
                            TextField("API Key", text: $apiKey)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            SecureField("API Key", text: $apiKey)
                                .textContentType(.password)
                        }
                        Button {
                            showKey.toggle()
                        } label: {
                            Image(systemName: showKey ? "eye.slash" : "eye")
                                .foregroundColor(.f1TextSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                    TextField("Model", text: $model)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(.subheadline, design: .monospaced))
                } header: {
                    Text("LLM API Configuration")
                } footer: {
                    Text("Supports any OpenAI-compatible endpoint (Groq, Together, Ollama, etc.)")
                }

                Section {
                    Button("Save") {
                        configStore.config = AIConfig(endpoint: endpoint, apiKey: apiKey, model: model)
                        withAnimation { saved = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { dismiss() }
                    }
                    .disabled(endpoint.isEmpty || apiKey.isEmpty || model.isEmpty)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                }

                if saved {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.f1NeonGreen)
                            Text("Configuration saved")
                                .foregroundColor(.f1NeonGreen)
                        }
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Need an API key?")
                            .font(.subheadline.weight(.semibold))
                        Link("Get a free Groq API key", destination: URL(string: "https://console.groq.com/keys")!)
                            .font(.caption)
                        Link("Together.ai API keys", destination: URL(string: "https://api.together.ai/settings/api-keys")!)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("AI Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.f1TextSecondary)
                }
            }
            .onAppear {
                endpoint = configStore.config.endpoint
                apiKey = configStore.config.apiKey
                model = configStore.config.model
            }
        }
        .preferredColorScheme(.dark)
    }
}
