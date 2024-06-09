# Stripe Subscriptions

This is a brief guide to get you started with running the application locally.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- docker


## Installation

1. Clone the repository to your local machine:

   ```bash
   git clone git@github.com:Natisk/stripe_subscriptions.git

2. `cd stripe_subscriptions`
 
2. Run `docker compose build`

2. Create stripe account on [stripe.com](https://stripe.com).

3. Go to dashboard -> Developers -> API keys     

5. In the application root folder create `.env` file according to `.env.example`
  
7. Add API key to `.env` file

8. Run
   ```bash
   docker compose run stripe

9. Stripe CLI will provide you a link for authentication.
10.  Follow the link and confirm authentication on stripe web site.

11. Run again
    ```bash
    docker compose run stripe

12. Now Stripe CLI will give you webhook secret, paste it to `.env`
13. Stop that container and Run
    ```bash
    docker compose up

14. Now you can crate Subscriptions on Stripe web interface or open new terminal tab and run
    ```bash
    docker compose run --rm stripe trigger customer.subscription.created

    ```  
    or
    ```bash
    docker compose run --rm stripe trigger customer.subscription.deleted

15. Visit localhost:3000 to see newly created subscription
