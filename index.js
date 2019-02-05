import { NativeModules } from 'react-native';
const { RNDrift } = NativeModules;

export default class Drift {

    static setup(id) {
        return RNDrift.setup(id);
    }

    static registerUser(id, email) {
        return RNDrift.registerUser(id, email);
    }

    static logout() {
        return RNDrift.logout();
    }

    static showConversations() {
        return RNDrift.showConversations();
    }

    static showCreateConversation() {
        return RNDrift.showCreateConversation();
    }
}
