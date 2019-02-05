import { NativeModules } from 'react-native';

const { RNDrift } = NativeModules;

export function setup(id) {
    return RNDrift.setup(id);
}

export function registerUser(id, email) {
    return RNDrift.registerUser(id, email);
}

export function logout() {
    return RNDrift.logout();
}

export function showConversations() {
    return RNDrift.showConversations();
}

export function showCreateConversation() {
    return RNDrift.showCreateConversation();
}
