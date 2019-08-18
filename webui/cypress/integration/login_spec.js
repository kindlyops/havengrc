describe('Login to application', function () {
    it('Opens the application!', function () {
        cy.visit('/')
        cy.contains('Login').click()
        cy.url().should('include', '/auth/realms/havendev/protocol/openid-connect')
        cy.contains('Log In With')
            .should('be.visible')
    })
})