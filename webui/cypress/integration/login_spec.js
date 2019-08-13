// Stores the magiclink for usage across tests.
let magicLink = "";
// Save these cookies across tests.
Cypress.Cookies.defaults({
    whitelist: ['AUTH_SESSION_ID', 'KC_RESTART']
})

describe('Login to application', function () {
    it('Opens the application!', function () {
        cy.visit('/')
        cy.contains('Login').click()
        cy.url().should('include', '/auth/realms/havendev/protocol/openid-connect')
    })
})

describe('Login with magiclink', function () {
    it('Creates a magiclink!', function () {
        cy.visit('/')
        cy.contains('Login').click()
        cy.url().should('include', '/auth/realms/havendev/protocol/openid-connect')
        cy.get('[id="zocial-magic-link"]').click()
        cy.url().should('include', '/auth/realms/havendev/protocol/openid-connect/auth?client_id=magic-link')
        cy.get('#email').type('user1@havengrc.com')
        cy.get('#kc-login').click()
        cy.url().should('include', '/auth/realms/havendev/login-actions/authenticate')
    })

    it('Get the magiclink!', function () {
        cy.request('http://mailhog:8025/api/v2/messages').then((response) => {
            // response.body is not automatically serialized into JSON
            let body = JSON.parse(response.body);
            expect(body).to.have.property('items')
            let email = body['items'][0]['Content']['Body']
            let urlString = decode_utf8(email)
            magicLink = urlString.match(/"([^"]+)"/)[1];
        })
    })

    it('Use the magiclink!', function () {
        cy.visit(magicLink)
        cy.contains('Dashboard').click()
        cy.url().should('include', 'dashboard')
    })
})

// Helper function to aid with decoding the email
function decode_utf8(s) {
    return decodeURIComponent(escape(s));
}