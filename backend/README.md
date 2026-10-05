# Backend Integration Layer

Planned responsibilities:

- create and track payment intents
- persist merchant/payment metadata
- monitor PaymentReceived and Settlement events
- expose transaction status to the frontend
- validate request payloads before submitting blockchain transactions

The backend must never request or store a user's seed phrase or private key.
